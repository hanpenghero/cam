import requests
import json

print("Cloud Automation Manager APIs - Demo Python Script")

protocol='https://'
host='9.111.216.23'
camPort='30000'
icpPort='8443'
user='admin'
pw='admin'

cam=protocol + host + ":" + camPort
icp=protocol + host + ":" + icpPort


postdata = "grant_type=password&username=" + user + "&password=" + pw + "&scope=openid"
head = {'Content-Type':'application/x-www-form-urlencoded', 'Accept':'application/json', "charset" : "UTF-8"}
ret = requests.post(icp + "/idprovider/v1/auth/identitytoken",
                     data=postdata,
                     headers=head,
                     verify=False)
access_token=ret.json()["access_token"]
print("access_token", access_token)


head = {"Authorization": "bearer " + access_token}
ret = requests.get(cam + "/cam/tenant/api/v1/tenants/getTenantOnPrem",
                     headers=head,
                     verify=False)
tenantId=ret.json()["id"]
namespace=ret.json()["namespaces"][0]["uid"]
if user != 'admin':
    team=ret.json()["namespaces"][0]["teamId"]
else:
    team='all'
print("tenantId", tenantId)
print("team", team)

parameters={"tenantId":tenantId, "ace_orgGuid":team, "cloudOE_spaceGuid":namespace}
head = {"Authorization": "bearer " + access_token, 'Accept':'application/json'}
ret = requests.get(cam + "/cam/api/v1/stacks",
                     headers=head,
                     params=parameters,
                     verify=False)
print("ret",cam + "/cam/api/v1/stacks",
                     headers=head,
                     params=parameters,
                     verify=False)
stacks=json.dumps(ret.json())
print("stacks", stacks)
