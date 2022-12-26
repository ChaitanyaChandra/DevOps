> Ansible Solves
* Imperative replacing with Declarative
* Simple declarative supports heterogeneous OS
* Parallel operations are possible
* Code need not to be on the server

> Push

* Once you push and changes made later manually on server are not been taken care
> Pull

* Pull will happen by an additional agent runs on the client machines, Meaning one more software run and involves operations.

* What if that agent is crashing ? Pull never gives centralized report.

> ###  Ansible offers both push and pull mechanism.

* untill v2.9 --> modules 
    * ex: copy

</br>

* after 2.10 --> collections
    * ex: ansible.builtin.copy

> Inventory

* We can keep either IP address or Hostname.
    * ex: 127.0.0.1, server1.chaitu.net

</br>

* Grouping can be done either <B> individual files </B> based on environment or based on component and even together and that always depends upon the architecture design that project had.

* In environments like a cloud where the nodes are too dynamic and where your IP addresses always change frequently, we need to work on some  <B> dynamic inventory  </B> management. 

> Ad-Hoc commands

* ```
  ansible -m ping localhost
  ```
* problems with <b> Ad-Hoc </b> commands
    * multiple tasks, error handeling,
    * logical limitations 

> Ansible playbook
* Playbook has multiple plays.
* Playbook file itself is a list.
* Playbook book should have at least one play.
* Play must have information about the inventory group. (hosts)
* It should have the information that it should load tasks or roles.
* In general, we provide an optional key name to denote the purpose of the play & task.

    ```
    - hosts: DATABASES
    tasks:
        - ansible.builtin.debug:
            msg: "Hello World"

    - name: Play 2
    hosts: APPLICATION
    roles:
        - roleA
        - roleB
    ```

> When to Quote for Values
* Ansible Values supports Double Quotes & Single Quotes.
* In Double Quotes & Single Quotes we can access variables.
* Quotes are necessary, if the value starts with variable then we have to quote it, Otherwise quotes are not necessary.

> Variable Precedence (prioritized Order is high to low)
* Command line variables
* Task Level Variables
* vars dir from roles
* Variable from files 
* Play level variable
* Inventory variables 
    
    * Group variables
    * Host variables 
* default dir from roles

> Ansible Pre-Defined Variables (Facts)
* From a task output (register)
* Set a variable using task (set_fact) (collection)

