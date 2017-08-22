<powershell>
  winrm set winrm/config/service/Auth '@{Basic="true"}'
  winrm set winrm/config/service '@{AllowUnencrypted="true"}'
  winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'
  netsh advfirewall firewall add rule name="WinRM Inbound" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
  # Set Administrator password
  try {
  	$admin = [adsi]("WinNT://./administrator, user")
  	$admin.psbase.invoke("SetPassword", "${admin_password}")
    "${admin_password}" | Out-File c:\test_admin_password.log
  }
  catch {
  	"Error... Could not set password to: ${admin_password}. Exception was: $($_.Exception.message)" | Out-File c:\set_admin_password_error.log
    Write-Host "FATAL: Could not set admin password"
    Exit
  }
</powershell>