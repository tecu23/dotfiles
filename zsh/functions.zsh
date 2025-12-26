# Kubernetes functions

# Switch namespace quickly
# kns() {
#     if [ -z "$1" ]; then
#         kubectl config view --minify --output 'jsonpath={..namespace}'
#         echo
#     else
#         kubectl config set-context --current --namespace=$1
#     fi
# }
#
# # Get pod logs by partial name match
# klog() {
#     local pod=$(kubectl get pods | grep $1 | head -1 | awk '{print $1}')
#     if [ -z "$pod" ]; then
#         echo "No pod found matching: $1"
#         return 1
#     fi
#     echo "Tailing logs for: $pod"
#     kubectl logs -f $pod
# }
#
# # Execute command in pod by partial name match
# kexec() {
#     local pod=$(kubectl get pods | grep $1 | head -1 | awk '{print $1}')
#     if [ -z "$pod" ]; then
#         echo "No pod found matching: $1"
#         return 1
#     fi
#     echo "Executing in pod: $pod"
#     kubectl exec -it $pod -- ${2:-/bin/sh}
# }
#
# # Git functions
#
# # Create branch and push to remote
# gcbp() {
#     if [ -z "$1" ]; then
#         echo "Usage: gcbp <branch-name>"
#         return 1
#     fi
#     git checkout -b $1 && git push -u origin $1
# }
#
# # Quick commit and push
# gcp() {
#     if [ -z "$1" ]; then
#         echo "Usage: gcp <commit-message>"
#         return 1
#     fi
#     git add . && git commit -m "$1" && git push
# }
#
# # GCP functions
#
# # Switch GCP project quickly
# gcpswitch() {
#     if [ -z "$1" ]; then
#         echo "Current project: $(gcloud config get-value project)"
#         echo "Available projects:"
#         gcloud projects list --format="table(projectId,name)"
#         return 0
#     fi
#     gcloud config set project $1
# }
#
# # Get GKE credentials
# gke-creds() {
#     if [ -z "$1" ] || [ -z "$2" ]; then
#         echo "Usage: gke-creds <cluster-name> <region>"
#         return 1
#     fi
#     gcloud container clusters get-credentials $1 --region $2
# }
#
# # Terraform functions
#
# # Terraform plan with colored output saved to file
# tfplan() {
#     terraform plan -out=tfplan.out | tee tfplan.log
# }
#
# # Terraform apply the saved plan
# tfapply() {
#     if [ ! -f tfplan.out ]; then
#         echo "No tfplan.out found. Run tfplan first."
#         return 1
#     fi
#     terraform apply tfplan.out
# }
#
# # Utility functions
#
# # Create directory and cd into it
# mkcd() {
#     mkdir -p "$1" && cd "$1"
# }
#
# # Extract any archive
# extract() {
#     if [ -f "$1" ]; then
#         case "$1" in
#             *.tar.bz2) tar xjf "$1" ;;
#             *.tar.gz) tar xzf "$1" ;;
#             *.bz2) bunzip2 "$1" ;;
#             *.rar) unrar x "$1" ;;
#             *.gz) gunzip "$1" ;;
#             *.tar) tar xf "$1" ;;
#             *.tbz2) tar xjf "$1" ;;
#             *.tgz) tar xzf "$1" ;;
#             *.zip) unzip "$1" ;;
#             *.Z) uncompress "$1" ;;
#             *.7z) 7z x "$1" ;;
#             *) echo "'$1' cannot be extracted via extract()" ;;
#         esac
#     else
#         echo "'$1' is not a valid file"
#     fi
# }
#
# # Show disk usage of directories
# dusage() {
#     du -sh ${1:-.}/* | sort -h
# }
#
# # Find process using port
# port() {
#     lsof -i :$1
# }
