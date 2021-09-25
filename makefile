prep_new_disk:
	ansible-playbook -b -v prep_add_new_disk.yaml --limit mediaserver --ask-become-pass --vault-password-file .vault-password

migrate_disk:
	ansible-playbook -b -v migrate_data.yaml --limit mediaserver --ask-become-pass --vault-password-file .vault-password

init_mediaserver:
	ansible-playbook -b run.yaml --limit mediaserver --ask-become-pass --vault-password-file .vault-password

add_new_disk:
	ansible-playbook -b run.yaml --tags disks --limit mediaserver --ask-become-pass --vault-password-file .vault-password

install_containers:
	ansible-playbook -b run.yaml --tags container-apps --limit mediaserver --ask-become-pass --vault-password-file .vault-password

install_samba:
	ansible-playbook -b run.yaml --tags file-sharing --limit mediaserver --ask-become-pass --vault-password-file .vault-password

install_telegraf:
	ansible-playbook -b run.yaml --limit mediaserver --tags telegraf --ask-become-pass --vault-password-file .vault-password

list_disk_ids:
	lsblk |awk 'NR==1{print $0" DEVICE-ID(S)"}NR>1{dev=$1;gsub("[^[:alnum:]]","",dev);printf $0"\t\t";system("find /dev/disk/by-id -lname \"*"dev"\" -printf \" %p\"");print "";}'

run_mergerfs:
	ansible-playbook -b run.yaml --limit mediaserver --tags mergerfs --ask-become-pass --vault-password-file .vault-password

reqs:
	ansible-galaxy install -r requirements.yaml
	ansible-galaxy collection install -r requirements.yaml

forcereqs:
	ansible-galaxy install -r requirements.yaml --force

decrypt:
	ansible-vault decrypt --vault-password-file .vault-password vars/vault.yaml

encrypt:
	ansible-vault encrypt --vault-password-file .vault-password vars/vault.yaml

# cloud:
# 	cd terraform/cloud; terraform apply

# cloud-destroy:
# 	cd terraform/cloud; terraform destroy

gitinit:
	./git-init.sh
	echo "ansible vault pre-commit hook installed"
	echo "don't forget to create a .vault-password too"