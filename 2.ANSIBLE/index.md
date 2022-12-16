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

