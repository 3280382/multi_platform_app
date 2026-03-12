#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <linux/limits.h>
#include <unistd.h>

#include <cstdlib>
#include <iostream>
#include <memory>
#include <optional>

#include "flutter/generated_plugin_registrant.h"

int main(int argc, char** argv) {
  gtk_init(&argc, &argv);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, argv + 1, argc - 1);

  g_autoptr(FlView) view = fl_view_new(project);
  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_show(GTK_WIDGET(view));
  gtk_window_set_default_size(GTK_WINDOW(view), 1280, 720);

  gtk_main();
  return EXIT_SUCCESS;
}
