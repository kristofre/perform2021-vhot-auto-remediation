## Lab Setup

In this lab we will run  the scripts to install the packages and create configurations needed.

1. Install required packages:

    ```bash
    cd ~/scripts/
    ```

    ```bash
    ./install_packages.sh && source ~/.bashrc
    ```

1. Run the following command to confirm that your public IP is set as an environment variable:

    ```bash
    echo $PUBLICIP
    ```

1. Create the extra vars file (HAProxy IP address will be provided by the instructor):

    ```bash
    cd ~
    ```

    ```bash
    ./define_credentials.sh
    ```
