# REPRODUCER

```
oc new-project ocp-iostat-build
```
```
oc get secret etc-pki-entitlement -n openshift-config-managed -o json | jq 'del(.metadata.creationTimestamp, .metadata.resourceVersion, .metadata.resourceVersion, .metadata.namespace, .metadata.uid)' | oc create -f -
```
```
curl -sk https://raw.githubusercontent.com/gmeghnag/ocp-iostat-build/refs/heads/main/task.yaml | oc create -f -
```