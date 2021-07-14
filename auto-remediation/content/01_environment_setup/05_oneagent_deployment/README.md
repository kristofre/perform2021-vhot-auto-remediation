## OneAgent Deployment

1. Install the OneAgent ansible galaxy role:

    ```bash
    ansible-galaxy install dynatrace.oneagent
    ```

1. Install OneAgent:

    ```bash
    ansible-playbook ~/ansible/oneagent.yml
    ```

1. You can verify the OneAgent intallation by running the following command:

    ```bash
    systemctl status oneagent
    ```

1. On dynatrace navigate to `Hosts`, search for your host and ensure that the metadata set during the deployment of the OneAgent is visible:

    ![haproxy-template](../../../assets/images/dynatrace-host-metadata.png)
