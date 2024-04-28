package types

type SData interface {
	isData()
}

type JsonData struct {
	Data map[string]interface{}
}

func (*JsonData) isData() {}

type HtmlData struct {
	Data string
}

func (*HtmlData) isData() {}