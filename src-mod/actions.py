
def action_backslash(context, word):
    return '\\', context.splitter.следующий('\n')

def action_colon(context, word):
    return '+', context.splitter.следующий(' ')

def action_semicolon(context, word):
    return '-', 'EXIT'

def action_quot(context, word):
    return '(")', context.splitter.следующий('"')

def action_dotquot(context, word):
    return '(.")', context.splitter.следующий('"')

def action_abortquot(context, word):
    return '(ABORT")', context.splitter.следующий('"')

def action_cquot(context, word):
    return 'C"', context.splitter.следующий(' ')

def action_b_comp(context, word):
    return '[comp]', context.splitter.следующий(' ')

def action_if(context, word):
    return 'if', None

def action_ifnot(context, word):
    return 'ifnot', None

def action_else(context, word):
    return 'else', None

def action_then(context, word):
    return 'then', None

def action_do(context, word):
    return 'do', None

def action_loop(context, word):
    return 'loop', None

def action_ploop(context, word):
    return '+loop', None

def action_begin(context, word):
    return 'begin', None

def action_again(context, word):
    return 'again', None

def action_repeat(context, word):
    return 'repeat', None

def action_until(context, word):
    return 'until', None

def action_bracket(context, word):
    return '(', context.splitter.следующий(')')

def action_lit_const(context, word):
    return 'lit_const', word.name
