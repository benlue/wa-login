exports.include = [
    {
        href: 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css',
        rel: 'stylesheet',
        integrity: 'sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH',
        crossorigin: 'anonymous'
    },
    {
        href: "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
    },
    {
        src: 'https://code.jquery.com/jquery-3.7.1.min.js',
        integrity: 'sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=',
        crossorigin: 'anonymous'
    },
    {
        src: 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js',
        integrity: 'sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz',
        crossorigin: 'anonymous'
    }
]


exports.view = function(model, ctx)  {
    /** This section will be the default for all layouts. **/
    const  head = xs.e('head')
                    .add('title', ctx.title)
                    .add('meta', 'http-equiv="X-UA-Compatible" content="IE=edge"')
                    .add('meta', 'http-equiv="Content-Type" content="text/html; charset=UTF-8"')

    if (ctx.description)
        head.add('meta', {name: 'description', content: ctx.description})

    // add include files
    if (model.include)
        model.include.forEach( inc => head.add( inc ) );
    /****** End of the default section ******/

    const  root = xs.root('html')
                    .add( head )
                    .add('body', xs.div({id: 'pgBody'}, model.body))

    return  root
}


exports.control = function(p) {}