cd ./terraform
terraform destroy -auto-approve
rm ~/.ssh/known_hosts
echo "done..."