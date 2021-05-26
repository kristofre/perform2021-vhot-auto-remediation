## ServiceNow Plugins

### Activate required ServiceNow plugin

If you already have the plugins below activated you can skip this step.

You can check if the plugins are activated by navigating to the `sys_plugins` table and searching them by ID (`com.glideapp.itom.snac`, `com.glide.hub.integrations`)

For specific instructions visit [Activate a plugin on a personal developer instance].

The following plugins must be enabled prior to this lab:

1. `Event Management` (com.glideapp.itom.snac) - Activation might take about 10-15 minutes, a confirmation email will be sent after it has been enabled.

    ![em-plugin](../../../assets/images/event-management-plugin.png)

1. `ServiceNow IntegrationHub Installer` (com.glide.hub.integrations) Activation might take about 5 minutes, a confirmation email will be sent after it has been enabled.

    ![ih-plugin](../../../assets/images/integration-hub-plugin.png)

[Activate a plugin on a personal developer instance]: https://docs.servicenow.com/bundle/paris-platform-administration/page/administer/plugins/task/activate-plugin-pdi.html
