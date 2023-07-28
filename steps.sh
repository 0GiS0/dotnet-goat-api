# Deploy infrastructure with Terraform
cd terraform
terraform fmt
terraform init -upgrade
terraform validate
az login
terraform plan
terraform apply -auto-approve

# Use Snyk to scan for vulnerabilities
cd ..
SNYK_TOKEN="<your-snyk-token>"
snyk auth $SNYK_TOKEN

# Scan for vulnerabilities
snyk code test --all-projects --sarif > results.sarif

# Snapshot and continuously monitor a project for open source vulnerabilities and license issues.
snyk monitor --all-projects

# Scan for IaC vulnerabilities
cd terraform
snyk iac test 

##### Using GitHub CLI ######
gh auth login
SQL_CONNECTION_STRING=$(terraform  output -raw connection_string)
gh secret set SQL_CONNECTION_STRING --body "$SQL_CONNECTION_STRING"

# Create a service principal for GitHub Actions
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
AZURE_CREDENTIALS=$(az ad sp create-for-rbac \
--name sp-for-github-runner \
--role Contributor \
--scopes /subscriptions/${SUBSCRIPTION_ID} \
--sdk-auth)

# Create a secret for the service principal
gh secret set AZURE_CREDENTIALS --body "$AZURE_CREDENTIALS"