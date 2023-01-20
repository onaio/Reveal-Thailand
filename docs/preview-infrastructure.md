# REVEAL THAILAND PREVIEW

## Architecture

The following diagram shows the infrastructure setup for the reveal thailand preview.
![Architecture](./images/reveal\_thailand\_preview\_infrastructure\_architecture.png)

## Server Access

The server setup runs behind a VPN. For access a user needs to set up a VPN client. The following are the steps to follow:

*   Install SSL VPN PLUS application from https://203.151.101.228.
*   Get credentials for the portal above from bitwarden.
*   Download & Extract the archived VPN application.
*   Install the application.

```shell
./install_linux_phat_client.sh
```

*   Execute the [naclient-helper.sh](#scripts) script to initiate a VPN session

## Setting up the servers

Before deployments begin one has to prepare the servers for an ansible deployment.

*   (Application, Database and Reporting Server) Create the same user on all the servers.
    *   User should have sudo rights.
    *   User should have a NOPASSWD attribute.
    *   On the preview servers given ubuntu user has been created with the above attributes as follows:
    ```shell
    adduser ubuntu && usermod -aG sudo ubuntu && echo "ubuntu ALL=(ALL) NOPASSWD:ALL
    " > /etc/sudoers.d/ubuntu
    ```
    *   The password of the user is on the Reveal Thailand Bitwarden Collection.
*   (Local machine) Clone the following repositories in the same folder.
    *   https://github.com/opensrp/playbooks
    *   https://github.com/onaio/Reveal-Thailand
*   (Local machine) Create a python virtual environment on your machine to isolate ansible python dependencies.
    *   Install python if its missing, check using `python3 --version`
        ```shell
        sudo apt install python3  python3-pip  python3.10-venv -y
        ```
    *   Create `~/.opensrp` python virtual environment
        ```shell
        python3 -m venv ~/.opensrp
        ```
    *   Switch to `~/.opensrp` python virtual environment
        ```shell
        source ~/.opensrp/bin/activate
        ```
*   (Local machine) Run server setup playbook
    *   Server setup playbook setups up the SSH keys and monitoring tools on the servers.
    *   Create a ~/.vaultpass file which stores the vault password.
    *   Get the password from Reveal Thailand Bitwarden Collection.
    *   Ensure you are connected to the VPN.
    *   Ensure you are in the opensrp virtual environment.
    *   cd into the playbooks repository
        ```shell
        cd playbooks
        ```
    *   Install ansible dependencies as follows:
        *   Install pip packages
        ```shell
        pip install -r requirements/base.pip
        ```
        *   Install ansible galaxy roles
        ```shell
        ansible-galaxy role install -r requirements/ansible-galaxy.yml -p ~/.ansible/roles/opensrp
        ```
        *   Install ansible galaxy collection
        ```shell
        ansible-galaxy collection install -r requirements/ansible-galaxy.yml -p ~/.ansible/collections/opensrp
        ```
        *   Execute the following ansible-playbook command to run server setup.
        *   For the initial server setup append -k argument on the below command to supply the ubuntu password.
        ```shell
        ansible-playbook -i ../Reveal-Thailand/ansible/inventories/preview/opensrp-stack/ setup-server.yml --vault-password=~/.vaultpass  -e ansible_user=ubuntu -e ansible_ssh_user=ubuntu --skip-tags sre-tooling
        ```
*   (Local machine) Create GPG keys for database backups if they do not exist
    https://smartregister.atlassian.net/wiki/spaces/Documentation/pages/2855305233/Generating+GPG+keys
    *   Save it in the ansible/inventories/preview/opensrp-stack/files/pgp folder.
    *   Encrypt the files with ansible vault command.
    ```shell
    ansible-vault encrypt ansible/inventories/preview/opensrp-stack/files/pgp/<file-name> --vault-password=~/.vaultpass
    ```
*   (Local machine) Create SSL certificates to encrypt the end to end communication between opensrp server and postgresql database.
    *   ```shell
        openssl req -newkey rsa:2048 -nodes -keyout root.key -out root.csr
        ```
    *   ```shell
        openssl x509 -signkey root.key -in root.csr -req -days 3650 -out root.crt
        ```
    *   To be renewed after 10 yrs
    *   Save the files in ansible/inventories/preview/opensrp-stack/files/tls folder.
    *   Encrypt the files with ansible vault command.
    ```shell
    ansible-vault encrypt ansible/inventories/preview/opensrp-stack/files/tls/<file-name> --vault-password=~/.vaultpass
    ```
    *   (Local machine) Add SSL certificates for the external facing services.
        *   Save the files in ansible/inventories/preview/opensrp-stack/files/ssl folder.
        *   Encrypt the files with ansible vault command.
        ```shell
        ansible-vault encrypt ansible/inventories/preview/opensrp-stack/files/ssl/<file-name> --vault-password=~/.vaultpass
        ```
        *   Examples
            *   ```shell
                ansible-vault encrypt ansible/inventories/preview/opensrp-stack/files/ssl/star.ddc-malaria.org.crt --vault-password=~/.vaultpass
                ```
            *   ```shell
                ansible-vault encrypt ansible/inventories/preview/opensrp-stack/files/ssl/star.ddc-malaria.org.key --vault-password=~/.vaultpass
                ```
*   (Local machine) Deploy opensrp
    *   Ensure you are connected to the VPN.
    *   Ensure you are in the playbooks repository.
    *   Ensure you are in the opensrp virtual environment.
    *   Execute the following
        *   ```shell
            ansible-playbook -i ../Reveal-Thailand/ansible/inventories/preview/opensrp-stack/ deploy-opensrp.yml --vault-password=~/.vaultpass  -e ansible_user=ubuntu -e ansible_ssh_user=ubuntu
            ```
*   (Local machine) Deploy keycloak
    *   Ensure you are connected to the VPN.
    *   Ensure you are in the playbooks repository.
    *   Ensure you are in the opensrp virtual environment.
    *   Execute the following
        *   ```shell
            ansible-playbook -i ../Reveal-Thailand/ansible/inventories/preview/opensrp-stack/ deploy-keycloak.yml --vault-password=~/.vaultpass  -e ansible_user=ubuntu -e ansible_ssh_user=ubuntu
            ```
*   (Local machine) Deploy opensrp web
    *   Ensure you are connected to the VPN.
    *   Ensure you are in the playbooks repository.
    *   Ensure you are in the opensrp virtual environment.
    *   Execute the following
        *   ```shell
            ansible-playbook -i ../Reveal-Thailand/ansible/inventories/preview/opensrp-stack/ reveal-web.yml --vault-password=~/.vaultpass  -e ansible_user=ubuntu -e ansible_ssh_user=ubuntu
            ``` 
*   (Local machine) Deploy superset
    *   Ensure you are connected to the VPN.
    *   Ensure you are in the playbooks repository.
    *   Ensure you are in the opensrp virtual environment.
        1. Create database and database user manually and set the database user as the database owner
           ```sql
           CREATE ROLE <database_owner> WITH LOGIN PASSWORD '<database_password>';`
           CREATE DATABASE <database_name> OWNER <database_owner>;`
           ```
        2. Replace the variables to match the ones intended for the instance
           - superset/vars.yml
             ```yml
             superset_server_name: <your.domain.name>
             opensrp_client_id: <opensrp-client-id>
             keycloak_url: <keycloak-url>
             api_base_url: <opensrp-api-base-url>
             superset_postgres_db_user: <database_owner> # database user created in the previous step
             superset_postgres_db_name: <database_name> # database name created in the previous step
             ```
           - superset/vault.yml
             ```yml
             vault_superset_postgres_db_pass: <database_password> # database password we created in the previous step
             vault_superset_postgres_db_host: <database_host> # ip or url
             ```
        3. Deploy service by running
           ```shell
            ansible-playbook -i ../Reveal-Thailand/ansible/inventories/preview/opensrp-stack superset.yml --vault-password=~/.vaultpass  -e ansible_user=ubuntu -e ansible_ssh_user=ubuntu
           ```
        4. ssh to the instance
        5. Activate virtual env by running
           ```shell
            source /home/superset/.virtualenv/superset/bin/activate
           ```
        6. Then run the following
           ```shell 
           export FLASK_APP=superset
           export PYTHONPATH="/home/superset/app:$PYTHONPATH"
           superset db upgrade
           superset init
           systemctl restart superset.service
           ```
*   (Local machine) Deploy Canopy Database
    *   Ensure you are connected to the VPN.
    *   Ensure you are in the playbooks repository.
    *   Ensure you are in the opensrp virtual environment.
    1. Create database and database user manually and set the database user as the database owner
       ```sql
       CREATE ROLE <database_owner> WITH LOGIN PASSWORD '<database_password>';`
       CREATE DATABASE <database_name> OWNER <database_owner>;`
       ```
    2. Replace the variables to match the ones intended for the instance
       - sqitch_migrations/vars.yml
         ```yml
         superset_postgres_db_user: <database_owner># database user we just created in the previous step
         reveal_migrations_db_name: <database_name> # database name we just created in the previous step
         ```
       - sqitch_migrations/vault.yml
         ```yml
         vault_db_admin_username: # username for a user that can create a database in the database instance, usually the superuser
         vault_db_admin_password: # password for the user defined in `vault_db_admin_username`
         vault_db_user_username: <database_owner> # database user created in the previous step
         vault_db_user_password: <database_password> # database password created in the previous step
         vault_db_host: <database_host> # ip or url
         ```
       ```shell
       ansible-playbook -i ../Reveal-Thailand/ansible/inventories/preview/opensrp-stack/ sqitch_migrations.yml --vault-password=~/.vaultpass  -e ansible_user=ubuntu -e ansible_ssh_user=ubuntu
       ``` 
Done.

## Scripts

### naclient-helper.sh

The script helps to initiate and maintain VPN session for the purpose of deployment.

*   Ensure that `REVEAL_TH_PREVIEW_NACLIENT_PASSWORD` environment variable is set. Obtain credentials from `Reveal Thailand Handover & Support` under password for `Vmware VPN Biophics Configuration Portal`.
*   To execute run:
    ```shell
    sudo -E ./scripts/naclient-helper.sh
    ```
*   When exiting with `Ctrl + C` wait for a few seconds to be logged out.
