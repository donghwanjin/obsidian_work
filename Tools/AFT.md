### Setup vnc password

set the password once by `$> vncpasswd`, and ensure your `$HOME/.vnc/config` has a line like:

`securitytypes=vncauth,tlsvnc`

then restart atf `atf restart`

issue you need to restart your PDE
![[Pasted image 20260105114259.png]]

### atf install 

