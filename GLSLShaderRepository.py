import subprocess
import os
import bpy


bl_info = {
    "name": "Shader Repository",
    "description": "Gets GLSL Shader from a repository.",
    "author": "Manuel Bellersen (Urfoex)",
    "version": (0, 1),
    "blender": (2, 66, 0),
    "location": "File > Import > GLSL Shader Repository",
    "warning": "Be sure to have Mercurial installed.",  # used for warning icon and text in addons panel
    "wiki_url": "https://bitbucket.org/Urfoex/bge-shader",
    "tracker_url": "https://bitbucket.org/Urfoex/bge-shader",
    "category": "Game Engine"
}


class GLSLShaderRepository(bpy.types.Operator):
    bl_idname = "wm.import_glsl_shader_repository"
    bl_label = "Import GLSL Shader Repository"
    bl_options = {'REGISTER'}

    repository = "https://bitbucket.org/Urfoex/bge-shader"
    repository_folder = "bge-shader"
    blend_file = os.path.basename(bpy.data.filepath)
    blend_path = os.path.dirname(bpy.data.filepath)
    repository_path = blend_path + os.sep + repository_folder

    #def __init__(self):
        #return

    def __del__(self):
        print("Removing repo:", self.repository_path)
        subprocess.call(args=['rm', "-r", self.repository_path])

    def execute(self, context):
        import time
        start_time = time.clock()
        print("execute started at:", start_time)

        print("execute finished at:", time.clock())
        print("took about", time.clock() - start_time, "s")
        return {'FINISHED'}

    def invoke(self, context, event):
        print("Invoke:", event)
        self.run()
        return {'RUNNING_MODAL'}

    def run(self):
        if not os.path.isdir(self.repository_path):
            print("Cloning:", self.repository, "to:", self.repository_path, "...")
            self.CloneRepository()
        else:
            print("Updating repository at:", self.repository_path, "...")
            self.UpdateRepository()

    def CloneRepository(self):
        subprocess.call(args=['hg', 'clone', self.repository], cwd=self.blend_path)

    def UpdateRepository(self):
        subprocess.call(args=['hg', 'update'], cwd=self.repository_path)


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