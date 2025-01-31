#
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
#

Name:       harbour-9store

# >> macros
# << macros

Summary:    9smart shop
Version:    0.2
Release:    6
Group:      Qt/Qt
License:    LICENSE
URL:        http://www.9smart.cn/
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-9store.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   pyotherside-qml-plugin-python3-qt5 >= 1.3.0
Requires:   dbus-python3
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils
%description
Short description of my SailfishOS Application


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre



%qtc_make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
make INSTALL_ROOT=%{buildroot} install
mkdir -p %{buildroot}/usr/share/%{name}/qml/py
mkdir -p %{buildroot}/usr/share/%{name}/qml/img
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop





%post
chmod a+x /usr/share/harbour-9store/qml/py/jobs.py
#systemctl start harbour-9store.timer
#systemctl enable harbour-9store.timer
#systemctl start harbour-9store.service
#systemctl enable harbour-9store.service

%preun

%postun
if [ $1 = 0 ]; then
    // Do stuff specific to uninstalls
systemctl stop harbour-9store.timer
systemctl disable harbour-9store.timer
systemctl stop harbour-9store.service
systemctl disable harbour-9store.service
rm /etc/systemd/system/harbour-9store.timer
rm /etc/systemd/system/harbour-9store.service
rm -rf /usr/share/harbour-9store
rm -rf /home/nemo/.local/share/harbour-9store/harbour-9store/QML/
else
if [ $1 = 1 ]; then
    // Do stuff specific to upgrades
echo "Upgrading"
fi
fi

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
/etc/systemd/system/
# >> files
# << files
