package model

type ThemeConfig uint8

const (
	FOLLOW_SYSTEM ThemeConfig = iota
	LIGHT
	DARK
)