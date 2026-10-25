#let template(body) = {
    set text( lang: "ja", size: 10.5pt, font: "Noto Serif CJK JP" )

    set page(
        paper: "a4",
        margin: (top: 25mm, bottom: 30mm, left: 30mm, right: 30mm),
        numbering: "1 / 1",
        number-align: center
    )

    set par(
        first-line-indent: (
            amount: 1em,
            all: true
        ),
        leading: 1em
    )

    set heading(numbering: "1.1　")
    // show heading.where(level: 1): set heading(numbering: "1.　")
    show heading: it => {
        set text(
            font: "Noto Sans CJK JP",
            weight: "bold"
        )

        if it.body == [参考文献] {
            [#it.body]
        } else if it.body == [付録] {
            [#it.body]
        } else {
            it
        }
    }

    set math.equation(numbering: "(1)")

    show figure.where(kind: image): set figure(supplement: "図")
    show figure.where(kind: image): set figure.caption(separator: "　", position: bottom)
    show figure.where(kind: table): set figure(supplement: "表")
    show figure.where(kind: table): set figure.caption(separator: "　", position: top)
    show figure.where(kind: raw): set figure(supplement: "リスト")
    show figure.where(kind: raw): set figure.caption(separator: "　", position: top)
    // show figure.where(kind: raw): set block(breakable: true)

    show "、": "，"
    show "。": "．"

    body
}
