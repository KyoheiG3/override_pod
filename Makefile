.PHONY: bootstrap
bootstrap:
	dart pub global activate melos
	dart pub get
	melos bootstrap
