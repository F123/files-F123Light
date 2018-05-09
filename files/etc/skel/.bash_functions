EC()
{
    echo -en '\e[1;33m'$? '\e[m';
}

trap EC ERR
