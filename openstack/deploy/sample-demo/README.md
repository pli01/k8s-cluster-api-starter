# demo

Deploy summy whoami app in cluster and expose app with ingress-nginx

Prereq:
- Assume an External LB is provisionned outside cluster-api. LB can contact worker node (http,https)
- external LB redirect trafic to port 80 or 443 on worker node with ingress-nginx

Run following scripts:
```
install_ingress-nginx.sh
install_whoami.sh
```
