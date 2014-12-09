module.exports = function(grunt)
{
    // project config
    grunt.initConfig(
    {
        pkg: grunt.file.readJSON('package.json'),

        copy:
        {
            exe:
            {
                expand: true,
                src: 'zentaorunner.exe',
                dest: 'D:\\xampp'
            },
            res:
            {
                expand: true,
                src: 'res\\**',
                dest: 'D:\\xampp\\runner'
            },
            langs:
            {
                expand: true,
                src: 'languages\\**',
                dest: 'D:\\xampp\\runner'
            }
        },

        watch:
        {
            exe:
            {
                files: 'zentaorunner.exe',
                tasks: ['copy']
            },
            run:
            {
                files: 'zentaorunner.exe',
                tasks: ['run']
            }
        },

        exec:
        {
            runexe:
            {
                command: 'D:\\xampp\\zentaorunner.exe',
                stdout: false,
                stderr: false
            }
        }
    });

    // These plugins provide necessary tasks.
    require('load-grunt-tasks')(grunt, {scope: 'devDependencies'});

    grunt.registerTask('run', ['copy', 'exec']);
    grunt.registerTask('default', ['run']);

    grunt.registerTask('watch-run', ['watch:run']);
}
