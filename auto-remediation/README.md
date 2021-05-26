# AIOps - Leverage the power of Davis for Auto-Remediation

## Steps (instructors)

### Components used in this session:

1. Ubuntu server (AWX/easyTravel) - 1 per student
1. Ubuntu server (HAProxy) - 1 per session
1. Dynatrace Tenant - 1 per student

Students will require the public IP address of the HAProxy server during the labs.

### Configure HAProxy

1. After logging in to the newly provisioned HAProxy server, run the following script:

    ```bash
    ./install_haproxy.sh
    ```

2. To retrieve the HAProxy public IP, run the following command:

    ```bash
    curl ifconfig.me
    ```
