## HAProxy Configuration

In this lab we will be adding your easyTravel app instance behind the existing HAProxy load balancer.

1. In Ansible AWX, navigate to `Templates` and click on the "rocket" icon next to the template named `haproxy configure`.

    ![haproxy-template](../../../assets/images/haproxy-template.png)

    **Note:** easyTravel Load balanced endpoint URL as well as HAProxy stats page will be part of playbook execution output.

1. Your easyTravel app instance should now be accessible via port 80 behind the HAProxy load balancer. To obtain the load balancer URL the following command can be run:

    ```bash
    echo http://$(cat ~/extra_vars.json | jq -r .haproxy_ip)/
    ```
