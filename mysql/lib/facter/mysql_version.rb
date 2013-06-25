Facter.add(:mysql_version) do
    setcode do
        Facter::Util::Resolution.exec("dpkg-query -W -f='${Version}\\n' mysql-server")
    end
end
