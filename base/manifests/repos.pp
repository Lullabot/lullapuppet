class base::repos {

    case $::osfamily {
        debian: { include base::repos::debian }
        redhat: { include base::repos::redhat }
    }

}
