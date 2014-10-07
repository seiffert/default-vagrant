class smtp::install {
	package { 
	    'postfix':
	    	ensure => present;
	    'sendmail':
	        ensure => absent;
	}

case $::osfamily {
   'redhat': {
   		package {
		'cyrus-sasl-plain':
			ensure => present;
		'cyrus-sasl-md5':
			ensure => present;
		'mailx':
	    	ensure => present;
		}	
     
   }
   'debian': {
   		package {
		'libsasl2-2':
			ensure => present;
		'libsasl2-modules':
			ensure => present;
		'mailutils':
	    	ensure => present;
		}	
   }
}


}