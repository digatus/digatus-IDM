# digatus Identity Management
Author: [Julian Pawlowski](mailto:julian.pawlowski@digatus.de)


## General remark

By offering these pages we are following the Microsoft recommendation from the deployment guide:
https://docs.microsoft.com/en-us/azure/active-directory/active-directory-passwords-best-practices#create-your-own-password-portal

In addition, we are referring to the IT support contact pages from quite many IT applications and services in order to have a central place to maintain that information and also to ensure that these information are available without login in case a user is unable to authenticate.

> #### Create your own password portal
> 
> Many customers choose to host a webpage and create a root DNS entry, like https://passwords.contoso.com. They populate this page with links to the following information:
> 
> Azure AD password reset portal - https://aka.ms/sspr
> Azure AD password reset registration portal - http://aka.ms/ssprsetup
> Azure AD password change portal - https://account.activedirectory.windowsazure.com/ChangePassword.aspx
> Other organization-specific information
> 
> In any email communications or fliers you send out you can include a branded, memorable URL that users can go to when they need to use the services. For your benefit, we have created a [sample password reset page](https://github.com/ajamess/password-reset-page) that you can use and customize to your organization’s needs.

The digatus version of those pages uses slightly different links to ensure proper branding when directing to the pages. We also use the Microsoft short URL service (aka.ms) wherever possible. Last but not least the real potential of Bootstrap is leveraged here to provide a better user experience on both mobile and desktop devices.


## Referring to these pages

### Azure hosting

These pages are hosted in an Azure Blob container which could be addressed directly.
However, this does not provide any flexibility to manipulate the user access:

* index.html is not automatically delivered when accessing the root directory
* users cannot be redirected from HTTP to HTTPS
* we cannot deliver HTTP security headers
* the containers URL is quite long and ugly

For this reason an Azure CDN page (based on the Verizon Premium version) was created under the URL digatus-idm.azureedge.net. It will automatically access the blob and it's backup version in the second Azure data center and using the premium version, we can manipulate the HTTP headers as well. All of this only costs a few cents per gigabyte and those are low volume pages anyway, so...

### Short links

Now that we have more flexibility, the URL is still not 100% digatus branded. As we want these service pages to be as independent from any other infrastructure or official websites and domains, it is worth saying that also the Azure CDN domain name should not be shared directly. Instead we are using the digatus own short URL service under the digat.us domain. That way we can always change the destination and it can also be links that could easily be remembered by IT service staff and end users likewise so one may quickly find the desired info when needed, without access to any corporate portals.

These short links may be shared to refer to the IDM pages:

- User onboarding: [digat.us/welcome](https://s.digat.us/welcome)
- User identity portal: [digat.us/account](https://s.digat.us/account)
- IT support: [digat.us/IT-support](https://s.digat.us/IT-support)
- Benutzer Onboarding (in german): [digat.us/Willkommen](https://s.digat.us/Willkommen)
- Benutzer ID Portal (in german): [digat.us/Konto](https://s.digat.us/Konto)
- IT Support (in german): [digat.us/IT-Hilfe](https://s.digat.us/IT-Hilfe)

Please note that whenever you may refer from any web pages or IT services in particular, you should not use the domain digat.us but instead s.digat.us together with the https:// prefix. That way we can ensure that from any IT maintained web pages there is no possibility for man-in-the-middle attacks to redirect users to any fraudulent pages. This is crucial for proper identity management.

However, when mentioning the short link to an end user on the phone, it is not beneficial to state that the user needs to type in an https:// link. In that case the main purpose of having a short link to be communicated to the user is more important, e.g. on the phone one would rather refer the user to digat.us/password instead of saying the complete URL http://s.digat.us/password.

Note: The need for using a separate sub-domain instead of directly adding https:// to digat.us is that that service does not provide proper SSL certificate and we wanted to be able to control the HTTPS security headers for the same reason stated above. That's why the s.digat.us sub-domain was also connected to Azure CDN.


### Other related short links

Besides referring to the digatus IDM pages, there are other short links in place that might be helpful to go even more directly to some places of IDM interest:

- digatus branded Office 365 login page: [digat.us/login](https://s.digat.us/login)
- digatus intranet page: [digat.us/digatusNet](https://s.digat.us/digatusNet)

- digatus ID (alias for /account): [digat.us/ID](https://s.digat.us/ID)
- digatus password (alias for /account): [digat.us/password](https://s.digat.us/password)
- digatus Passwort (alias for /konto): [digat.us/Passwort](https://s.digat.us/Passwort)
- Password change (branded direct link): [digat.us/password-change](https://s.digat.us/password-change)
- Passwort ändern (branded direct link): [digat.us/Passwort-aendern](https://s.digat.us/Passwort-aendern)

- Password reset (branded direct link): [digat.us/password-reset](https://s.digat.us/password-reset)
- Passwort zurücksetzen (branded direct link): [digat.us/Passwort-reset](https://s.digat.us/Passwort-reset)

- Self-service password reset (branded direct link): [digat.us/SSPR](https://s.digat.us/SSPR)
- Self-service password reset setup (branded direct link): [digat.us/SSPRsetup](https://s.digat.us/SSPRsetup)
- Self-service MFA configuration (direct link): [digat.us/MFAsetup](https://s.digat.us/MFAsetup)
