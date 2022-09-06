# Create dir
mkdir -vp /home/student/local/mysql

# Add the appropriate SELinux context for the /home/student/local/mysql
# directory and its contents
sudo semanage fcontext -a \
-t container_file_t '/home/student/local/mysql(/.*)?'

# Apply the SELinux policy to the newly created directory
sudo restorecon -R /home/student/local/mysql

# Verify that the SELinux context type for the /home/student/local/mysql
# directory is container_file_t
ls -ldZ /home/student/local/mysql

# Change the owner of the /home/student/local/mysql directory to the mysql
# user and mysql group
podman unshare chown 27:27 /home/student/local/mysql

...
