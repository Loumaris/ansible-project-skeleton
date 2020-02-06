# loumaris ansible template

This project contains a basic ansible project setup. You can clone it and remove the  `.git/` folder
tp start a new project.

## usage

You can use `rake` to make your life easier:

```sh
rake -T
rake ansible:create_role        # create new role
rake ansible:install            # install requirements
rake ansible:update             # update requirements
rake production:deploy          # Deploy to production
rake production:describe-setup  # Show node setup of production
rake production:ping            # Run ping against nodes of production
rake production:prepare         # Prepare hosts for ansible in production.inventory.yml
rake production:vault           # Edit production.vault.yml for editing
rake site:create                # Create new ansible site (playbook, inventory, vault) and open the vault after it
```

## workflow

* define and install all dependencies: `rake ansible:install`
* you can update them as well: `rake ansible:update`
* if needed, create an environment (site): `rake site:create <environment>`
* if needed, create roles: `rake ansible:create_role <role name>`
* prepare the hosts (only on the first time a host joins): `rake <environment>:prepare`
* deploy the configuration: `rake <environment>:deploy`

That's it. Enjoy :)