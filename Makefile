install:
	swift build -c release
	install .build/release/stttool /usr/local/bin/stttool
