# Copyright 2025 Variscite
#
# SPDX-License-Identifier: BSD-3-Clause

# Flutter App Integration

flutter_app:
	@$(call fbprint_b,"flutter_app") && \
	echo "Creating flutter directories..." && \
	install -d $(DESTDIR)/opt/flutter && \
	install -d $(DESTDIR)/opt/flutter-app && \
	install -d $(DESTDIR)/usr/lib && \
	install -d $(DESTDIR)/etc/profile.d && \
	install -d $(DESTDIR)/etc/systemd/system && \
	install -d $(DESTDIR)/etc/udev/rules.d && \
	\
	echo "Installing Flutter engine from prebuilt binaries..." && \
	if [ -f $(FBDIR)/flutter-engines/libflutter_engine.so ]; then \
		install -m 0755 $(FBDIR)/flutter-engines/libflutter_engine.so $(DESTDIR)/usr/lib/; \
	else \
		echo "Warning: libflutter_engine.so not found in $(FBDIR)/flutter-engines/"; \
		echo "Please download from https://github.com/sony/flutter-embedded-linux/releases"; \
	fi && \
	\
	echo "Installing Flutter app if tar file exists..." && \
	if [ -f $(FBDIR)/flutter-app.tar.gz ]; then \
		cd $(DESTDIR)/opt/flutter-app && \
		tar -xzf $(FBDIR)/flutter-app.tar.gz --strip-components=1; \
	elif [ -f $(FBDIR)/flutter-app.tar ]; then \
		cd $(DESTDIR)/opt/flutter-app && \
		tar -xf $(FBDIR)/flutter-app.tar --strip-components=1; \
	else \
		echo "Warning: flutter-app.tar.gz or flutter-app.tar not found in $(FBDIR)/"; \
	fi && \
	\
	echo "Installing environment setup..." && \
	if [ -f $(FBDIR)/src/system/flutter/flutter-env.sh ]; then \
		install -m 0644 $(FBDIR)/src/system/flutter/flutter-env.sh $(DESTDIR)/etc/profile.d/flutter.sh; \
	else \
		echo "Warning: flutter-env.sh not found"; \
	fi && \
	\
	echo "Installing udev rules for device permissions..." && \
	if [ -f $(FBDIR)/src/system/udev/udev-rules-flutter/99-flutter.rules ]; then \
		install -m 0644 $(FBDIR)/src/system/udev/udev-rules-flutter/99-flutter.rules $(DESTDIR)/etc/udev/rules.d/; \
	else \
		echo "Warning: 99-flutter.rules not found"; \
	fi && \
	\
	echo "Installing systemd service..." && \
	if [ -f $(FBDIR)/src/system/flutter/flutter-app.service ]; then \
		install -m 0644 $(FBDIR)/src/system/flutter/flutter-app.service $(DESTDIR)/etc/systemd/system/; \
	else \
		echo "Warning: flutter-app.service not found"; \
	fi && \
	\
	echo "Creating startup script..." && \
	install -d $(DESTDIR)/usr/local/bin && \
	if [ -f $(FBDIR)/src/system/flutter/start-flutter-app.sh ]; then \
		install -m 0755 $(FBDIR)/src/system/flutter/start-flutter-app.sh $(DESTDIR)/usr/local/bin/; \
	else \
		echo "Warning: start-flutter-app.sh not found"; \
	fi && \
	\
	$(call fbprint_d,"flutter_app")
