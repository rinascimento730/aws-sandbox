# coding: utf-8
import os
import tornado.ioloop
import tornado.web
from tornado.web import url
import tornado.escape
from tornado.options import define, options
define("port", default=5000, type=int)

ROOT_DIR = os.path.dirname(__file__)
ROOT_JOIN = lambda sub_dir: os.path.join(ROOT_DIR, sub_dir)

from view import *

class Application(tornado.web.Application):
    def __init__(self):
        routers = [
            url(r'/', MainHandler, name='main'),
            url(r'/sub/', SubHandler, name='sub'),
            url(r'/index/', IndexHandler, name='index'),
            url(r'/python/', PythonHandler, name='python'),
            url(r'/php/', PHPHandler, name='php'),
            url(r'/ruby/', RubyHandler, name='ruby'),
            url(r'.*', BaseHandler, name='error_404'),
        ]

        settings = dict(
            static_path   = ROOT_JOIN("static"),
            template_path = ROOT_JOIN("templates"),
            autoescape    = "xhtml_escape",
            debug         = True,
        )

        tornado.web.Application.__init__(self, routers, **settings)

def main():
    options.parse_config_file(ROOT_JOIN('server.conf'))
    options.parse_command_line()
    app = Application()
    app.listen(options.port)
    tornado.ioloop.IOLoop.current().start()

if __name__ == "__main__":
    print("tornado!")
    main()
