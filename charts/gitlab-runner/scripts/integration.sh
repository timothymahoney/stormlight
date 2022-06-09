#!/bin/bash

INTEGRATION_RUNNER_NAME=${INTEGRATION_RUNNER_NAME:-integration-runner}
INTEGRATION_HELM_POD_RELEASE_LABEL=${INTEGRATION_HELM_POD_RELEASE_LABEL:-release=$INTEGRATION_RUNNER_NAME}

helm install -f values.yaml --timeout 5m --wait --set gitlabUrl="$CI_SERVER_URL",runnerRegistrationToken="$REGISTRATION_TOKEN" "$INTEGRATION_RUNNER_NAME" .

kubectl describe pod -l "$INTEGRATION_HELM_POD_RELEASE_LABEL"

timeout 60s grep -m1 "Runner registered successfully" <(kubectl logs -f -l "$INTEGRATION_HELM_POD_RELEASE_LABEL")

exit_code="$?"

kubectl logs -l "$INTEGRATION_HELM_POD_RELEASE_LABEL"

exit $exit_code
