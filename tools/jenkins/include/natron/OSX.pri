boost {
  BOOST_VERSION = 1.76
  INCLUDEPATH += /opt/local/libexec/boost/$$BOOST_VERSION/include
  LIBS += -L/opt/local/libexec/boost/$$BOOST_VERSION/lib -lboost_serialization-mt
}
equals(QT_MAJOR_VERSION, 5) {
  shiboken:  SHIBOKEN=shiboken2-$$PYVER
  shiboken:  INCLUDEPATH += $$PYTHON_SITE_PACKAGES/shiboken2_generator/include
  shiboken:  LIBS += -L$$PYTHON_SITE_PACKAGES/shiboken2 -lshiboken2.cpython-$$PYVERNODOT-darwin.$${QT_MAJOR_VERSION}.$${QT_MINOR_VERSION}
  shiboken:  QMAKE_RPATHDIR += $$PYTHON_SITE_PACKAGES/shiboken2
  pyside:    INCLUDEPATH += $$PYTHON_SITE_PACKAGES/PySide2/include
  pyside:    INCLUDEPATH += $$PYTHON_SITE_PACKAGES/PySide2/include/QtCore
  pyside:    INCLUDEPATH += $$PYTHON_SITE_PACKAGES/PySide2/include/QtGui
  pyside:    INCLUDEPATH += $$PYTHON_SITE_PACKAGES/PySide2/include/QtWidgets
  pyside:    LIBS += -L$$PYTHON_SITE_PACKAGES/PySide2 -lpyside2.cpython-$$PYVERNODOT-darwin.$${QT_MAJOR_VERSION}.$${QT_MINOR_VERSION}
  pyside:    QMAKE_RPATHDIR += $$PYTHON_SITE_PACKAGES/PySide2
  pyside:    TYPESYSTEMPATH *= $$PYTHON_SITE_PACKAGES/PySide2/typesystems
}

macx:openmp {
  # libomp 12+ has a bug on macOS when lanching tasks from a background thread,
  # see tools/MacPorts/lang/libomp/README.md
  LIBS += -L/opt/local/lib  -L/opt/local/lib/libomp -liomp5
  # These are set on the command-line, do not try to override it
  # search for 'printStatusMessage "Building Natron..."' in build-natron.sh
  # clang 17 and 18 with -fopenmp links with @rpath/libc++.1.dylib instead
  # of /usr/lib/libc++.1.dylib, so let's use clang 16 for now.
  #QMAKE_CC = /opt/local/bin/clang-mp-16
  #QMAKE_CXX = /opt/local/bin/clang++-mp-16
  # Recent clang cannot compile QtMac.mm
  #QMAKE_OBJECTIVE_CC = clang
  #QMAKE_OBJECTIVE_CXX = clang++
  #QMAKE_LINK = $$QMAKE_CXX
  INCLUDEPATH += /opt/local/include /opt/local/include/libomp
  cc_setting.name = CC
  cc_setting.value = $$QMAKE_CC
  cxx_setting.name = CXX
  cxx_setting.value = $$QMAKE_CXX
  # These settings are useless, unless someone finds out if there is a variable
  # to override the Objective-C compiler.
  objective_cc_setting.name = OBJECTIVE_CC
  objective_cc_setting.value = $$QMAKE_OBJECTIVE_CC
  objective_cxx_setting.name = OBJECTIVE_CXX
  objective_cxx_setting.value = $$QMAKE_OBJECTIVE_CXX
  ld_setting.name = LD
  ld_setting.value = $$QMAKE_CC
  ldxx_setting.name = LDPLUSPLUS
  ldxx_setting.value = $$QMAKE_CXX
  QMAKE_MAC_XCODE_SETTINGS += cc_setting cxx_setting objective_cc_setting objective_cxx_setting ld_setting ldxx_setting
  QMAKE_FLAGS = "-B /usr/bin"

  # clang (as of 12.0.1) does not yet support index-while-building functionality
  # present in Xcode 9 and later, and Xcode's clang (as of 13.0) does not yet support OpenMP
  compiler_index_store_enable_setting.name = COMPILER_INDEX_STORE_ENABLE
  compiler_index_store_enable_setting.value = NO
  QMAKE_MAC_XCODE_SETTINGS += compiler_index_store_enable_setting
}
