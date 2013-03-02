import subprocess
import os
import bpy
import shutil


bl_info = {
    "name": "Shader Repository",
    "description": "Gets GLSL Shader from a repository.",
    "author": "Manuel Bellersen (Urfoex)",
    "version": (0, 2),
    "blender": (2, 66, 0),
    "location": "File > Import > GLSL Shader Repository",
    "warning": "Be sure to have Mercurial installed.",  # used for warning icon and text in addons panel
    "wiki_url": "https://bitbucket.org/Urfoex/bge-shader",
    "tracker_url": "https://bitbucket.org/Urfoex/bge-shader",
    "category": "Game Engine"
}


gRepoObjects = {}
gRepoObjects['repository_src'] = "https://bitbucket.org/Urfoex/bge-shader"
gRepoObjects['repository_folder'] = "bge-shader"
gRepoObjects['repository_dest'] = bpy.utils.script_paths()[1]
gRepoObjects['repository'] = gRepoObjects['repository_dest'] + os.sep + gRepoObjects['repository_folder']
gRepoObjects['script_file'] = "GLSLShaderRepository.py"
gRepoObjects['script_src'] = gRepoObjects['repository'] + os.sep + gRepoObjects['script_file']
gRepoObjects['script_dest'] = gRepoObjects['repository_dest'] + os.sep + "addons" + os.sep + gRepoObjects['script_file']
gRepoObjects['template_path'] = "startup" + os.sep + "bl_ui"
gRepoObjects['template_file'] = "space_text.py"
gRepoObjects['template_src'] = gRepoObjects['repository'] + os.sep + gRepoObjects['template_file']
gRepoObjects['template_dest'] = bpy.utils.script_paths(gRepoObjects['template_path'])[0] + os.sep + gRepoObjects['template_file']
gRepoObjects['template_orig'] = bpy.utils.script_paths(gRepoObjects['template_path'])[0] + os.sep + gRepoObjects['template_file'] + ".orig"


class GLSLShaderRepository(bpy.types.Operator):
    bl_idname = "wm.import_glsl_shader_repository"
    bl_label = "Import GLSL Shader Repository"
    bl_options = {'REGISTER'}

    def __init_(self):
        print("Activation")

    def __del__(self):
        print("Activation")
        if os.path.exists(gRepoObjects['template_orig']):
            print("Restoring:", gRepoObjects['template_orig'], "to:", gRepoObjects['template_dest'])
            shutil.copy2(src=gRepoObjects['template_orig'], dst=gRepoObjects['template_dest'])

    def execute(self, context):
        print(":: inside execute ::")
        import time
        start_time = time.clock()
        print("execute started at:", start_time)
        self.run()
        print("execute finished at:", time.clock())
        print("took about", time.clock() - start_time, "s")
        return {'FINISHED'}

    def invoke(self, context, event):
        print(":: inside invoke ::")
        import time
        start_time = time.clock()
        print("execute started at:", start_time)
        self.run()
        print("execute finished at:", time.clock())
        print("took about", time.clock() - start_time, "s")
        return {'RUNNING_MODAL'}

    def run(self):
        retCode = 0
        if not os.path.isdir(gRepoObjects['repository']):
            print("Cloning:", gRepoObjects['repository_src'], "to:", gRepoObjects['repository'], "...")
            retCode = self.CloneRepository()
        else:
            print("Updating repository at:", gRepoObjects['repository'], "...")
            retCode += self.PullRepository()
            retCode += self.UpdateRepository()
        if retCode != 0:
            print("Please check the repository at:", gRepoObjects['repository'])
        else:
            if not os.path.exists(gRepoObjects['template_orig']):
                print("Saving:", gRepoObjects['template_dest'], "to:", gRepoObjects['template_orig'])
                shutil.copy2(src=gRepoObjects['template_dest'], dst=gRepoObjects['template_orig'])

            print("Modifying template file at:", gRepoObjects['template_dest'])
            shutil.copy2(src=gRepoObjects['template_src'], dst=gRepoObjects['template_dest'])

            print("Modifying script file at:", gRepoObjects['script_dest'])
            shutil.copy2(src=gRepoObjects['script_src'], dst=gRepoObjects['script_dest'])

    def CloneRepository(self):
        return subprocess.call(args=['hg', 'clone', gRepoObjects['repository_src']], cwd=gRepoObjects['repository_dest'])

    def UpdateRepository(self):
        return subprocess.call(args=['hg', 'update'], cwd=gRepoObjects['repository'])

    def PullRepository(self):
        return subprocess.call(args=['hg', 'pull'], cwd=gRepoObjects['repository'])


def menu_func(self, context):
    self.layout.operator(GLSLShaderRepository.bl_idname, text="GLSL Shader Repository")


def register():
    bpy.utils.register_class(GLSLShaderRepository)
    bpy.types.INFO_MT_file_import.append(menu_func)


def unregister():
    bpy.utils.unregister_class(GLSLShaderRepository)
    bpy.types.INFO_MT_file_import.remove(menu_func)


if __name__ == "__main__":
    register()
