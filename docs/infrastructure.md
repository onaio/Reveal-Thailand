# REVEAL THAILAND

# Scripts

## naclient-helper.sh

The script helps to initiate and maintain VPN session for the purpose of deployment.

*   Ensure that `REVEAL_TH_PREVIEW_NACLIENT_PASSWORD` environment variable is set. Obtain credentials from `Reveal Thailand Handover & Support` under password for `Vmware VPN Biophics Configuration Portal`.
*   To execute run:
    ```shell
    sudo -E ./scripts/naclient-helper.sh
    ```
*   When exiting with `Ctrl + C` wait till `naclient logout`.
