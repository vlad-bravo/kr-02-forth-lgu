
def action_backslash(context):
    return '\\', context.splitter.следующий('\n')

def action_colon(context):
    return '+', context.splitter.следующий(' ')

def action_semicolon(context):
    return '-', 'EXIT'

def action_dotquot(context):
    return '(")', context.splitter.следующий('"')

def action_cquot(context):
    return 'C"', context.splitter.следующий(' ')

def action_if(context):
    return 'if', None

def action_else(context):
    return 'else', None

def action_then(context):
    return 'then', None
