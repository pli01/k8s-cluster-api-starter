Sample cluster-templates

- copy sample.env
- modify
- generate yaml

```
# extract variables
clusterctl generate yaml  --from cluster-template-SAMPLE.yaml --list-variables

# generate yaml
( source myconf.env; clusterctl generate yaml  --from cluster-template-SAMPLE.yaml )
```
