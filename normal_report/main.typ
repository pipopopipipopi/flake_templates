#import "style/template.typ": template
#show: template

// 表紙
#set page(numbering: none)
#align(center)[
    #v(230pt)
    #text(
        size: 22pt,
    )[
        TODO:科目名など\
    ]
    #v(20pt)
    #text(
        size: 28pt,
    )[
        TODO:実験名など
    ]
    #v(30pt)
    #text(
        size: 14pt,
    )[
        TODO:学籍番号など \
        TODO:氏名など \
        \
        // #datetime.today().display("[year]年[month]月[day]日")
    ]
]
#pagebreak()

#set page(numbering: "1 / 1")
#counter(page).update(1)
