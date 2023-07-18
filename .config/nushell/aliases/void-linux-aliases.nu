######################################
#                 XBPS                #
#######################################

# some others are already set by the xtools package
export alias xalt = doas xbps-alternatives -s
export alias xalts = doas xbps-alternatives -l
export alias xclean = doas xbps-remove -Oo
export alias xdb = doas xbps-pkgdb
export alias xdba = doas xbps-pkgdb -a
export alias xf = xbps-fetch
export alias xqh = xbps-query -H
export alias xqo = xbps-query -O
export alias xr = doas xbps-remove
export alias xrc = doas xbps-reconfigure
export alias xrca = doas xbps-reconfigure -a
export alias xrr = doas xbps-remove -R
export alias xrsr = xbps-query --regex -Rs
export alias xu = doas xbps-install -Su
export alias xuu = xbps-src-update
export alias xver = xbps-checkvers -If "%n %r -> %s"

#######################################
#               SERVICES              #
#######################################

def "nu-complete sv-enable" [] {
	^ls /etc/sv | lines
}

def "nu-complete sv-disable" [] {
	^ls /var/service | lines
}

export def sv-enable [service: string@"nu-complete sv-enable"] {
  if ($"/etc/sv/($service)" | path exists) == false {
    print "Error: service doesn't exist"
  } else {
    doas ln -s $"/etc/sv/($service)" "/var/service"
  }
}

export def sv-disable [service: string@"nu-complete sv-disable"] {
  if ($"/var/service/($service)" | path exists) == false {
    print "Error: service is not enabled"
  } else {
    doas rm -rf $"/var/service/($service)"
  }
}
