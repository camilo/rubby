#include <ruby.h>
#include "librubby.h"


static VALUE
start (VALUE self){
  Start();
  return Qnil;
}

static VALUE
stop (VALUE self){
  Stop();
  return Qnil;
}

static VALUE
start_http_profiler(VALUE self){
  StartHTTTPProfiler();
  return Qnil;
}

static VALUE
push_url (VALUE self, VALUE url_string){
  GoString go_str = {RSTRING_PTR(url_string), rb_str_strlen(url_string)};
  PushUrl(go_str);
  return Qnil;
}

static VALUE
queue_size(VALUE self){
  return INT2NUM(queueSize());
}


void
Init_gubby(void){
  VALUE mGubby;
  mGubby = rb_define_module("Gubby");
  rb_define_singleton_method(mGubby, "start", start, 0);
  rb_define_singleton_method(mGubby, "stop", stop, 0);
  rb_define_singleton_method(mGubby, "push_url", push_url, 1);
  rb_define_singleton_method(mGubby, "queue_size", queue_size, 0);
  rb_define_singleton_method(mGubby, "start_http_profiler", start_http_profiler, 0);
}
