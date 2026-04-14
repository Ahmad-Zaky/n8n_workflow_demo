# Daily Failed Payments Report Workflow

- This workflow reads the failed requests from database and reformat them and send them to the team leader for more inspection.

> !!! NOTES !!!   
>
> * There are credentials used to be able to connect to the database, I am using .bash_aliases to set the environment variables for both Oracle and MSS databases, you can choose to set them in .bashrc or directly in this script as well.
> * The n8n exported workflow has demo default values for (to, from, script_base_dir, restcall_url) please set your own values for these defaults so you can run the workflow on your own machine successfully.
> * There are some nodes related to connecting to Expressvpn, and openvpn, if you don't need them just deactivate them and bypass them into next nodes.
> * This workflow runs better on linux/unix machines, so it may not be ready to run on windows machines.
> * The workflow depends on some tools like sqlplus64 be sure you have them installed on your machine.
> * You need to set your Email smtp credentials in order to send emails.
> * To run my scripts I am sshing to my local machine using private/public keys, so be sure you have configure your connection correctly so n8n instance can access and run the bash scripts found here in the repo.
