parse_git_branch ()
{
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1='\u \[\033[33m\]\W\[\033[32m\]$(parse_git_branch)\[\033[00m\] $ '
export PATH="~/bin:$PATH"

alias aws_vpc=$'aws ec2 describe-vpcs --query \'Vpcs[].{id:VpcId,cidr:CidrBlock,name:Tags[?Key==`Name`].Value[]|[0]}\''
alias aws_running=$'aws ec2 describe-instances \\
    --query \'Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key==`Name`]|
      [0].Value,Private:PrivateIpAddress,Public:PublicIpAddress}\' \\
    --filters "Name=instance-state-name,Values=running"'
alias aws_instances=$'aws ec2 describe-instances \\
    --query \'Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key==`Name`]|
      [0].Value,Private:PrivateIpAddress,Public:PublicIpAddress,State:State.Name}\''
