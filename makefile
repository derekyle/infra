add_new_disk:
	ansible-playbook -b -v add_new_disk.yaml --limit mediaserver --ask-become-pass --vault-password-file .vault-password

init_mediaserver:
	ansible-playbook -b run.yaml --limit mediaserver --ask-become-pass --vault-password-file .vault-password

install_containers:
	ansible-playbook -b run.yaml --tags container-apps --limit mediaserver --ask-become-pass --vault-password-file .vault-password

reqs:
	ansible-galaxy install -r requirements.yaml

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