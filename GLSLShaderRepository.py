import subprocess
import os
import bpy


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
gRepoObjects['blend_file'] = os.path.basename(bpy.data.filepath)
gRepoObjects['blend_path'] = os.path.dirname(bpy.data.filepath)
gRepoObjects['repository_src'] = "https://bitbucket.org/Urfoex/bge-shader"
gRepoObjects['repository_folder'] = "bge-shader"
gRepoObjects['repository_dest'] = bpy.utils.script_paths()[1] + os.sep + gRepoObjects['repository_folder']
gRepoObjects['template_path'] = "startup" + os.sep + "bl_ui"
gRepoObjects['template_file'] = "space_text.py"
gRepoObjects['template_src'] = gRepoObjects['repository_dest'] + os.sep + gRepoObjects['template_file']
gRepoObjects['template_dest'] = bpy.utils.script_paths(gRepoObjects['template_path'])[0] + os.sep + gRepoObjects['template_file']


class GLSLShaderRepository(bpy.types.Operator):
    bl_idname = "wm.import_glsl_shader_repository"
    bl_label = "Import GLSL Shader Repository"
    bl_options = {'REGISTER'}

    def __del__(self):
        import shutil
        print("Removing repo:", gRepoObjects['repository_dest'])
        print("(STUB)")

        src_file = gRepoObjects['template_src'] + ".orig"
        print("Restoring:", gRepoObjects['template_dest'], "from:", src_file)
        shutil.copy2(src=src_file, dst=gRepoObjects['template_dest'])

    def execute(self, context):
        print("_-execute-_")
        import time
        start_time = time.clock()
        print("execute started at:", start_time)
        self.run()
        print("execute finished at:", time.clock())
        print("took about", time.clock() - start_time, "s")
        return {'FINISHED'}

    def invoke(self, context, event):
        self.execute(context)
        return {'RUNNING_MODAL'}

    def run(self):
        retCode = 1
        if not os.path.isdir(gRepoObjects['repository_dest']):
            print("Cloning:", gRepoObjects['repository_src'], "to:", gRepoObjects['repository_dest'], "...")
            retCode = self.CloneRepository()
        else:
            print("Updating repository at:", gRepoObjects['repository_dest'], "...")
            retCode = self.UpdateRepository()
        if retCode != 0:
            print("Please check the repository at:", gRepoObjects['repository_dest'])
        else:
            import shutil
            print("Modifying template file at:", gRepoObjects['template_dest'])
            shutil.copy2(src=gRepoObjects['template_src'], dst=gRepoObjects['template_dest'])

    def CloneRepository(self):
        return subprocess.call(args=['hg', 'clone', gRepoObjects['repository_src']], cwd=gRepoObjects['blend_path'])

    def UpdateRepository(self):
        return subprocess.call(args=['hg', 'update'], cwd=gRepoObjects['repository_dest'])


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
