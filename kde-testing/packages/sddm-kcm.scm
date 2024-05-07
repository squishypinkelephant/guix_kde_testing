;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016 Thomas Danckaert <post@thomasdanckaert.be>
;;; Copyright © 2018 Meiyo Peng <meiyo.peng@gmail.com>
;;; Copyright © 2019 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2017, 2019, 2020 Hartmut Goebel <h.goebel@crazy-compilers.com>
;;; Copyright © 2019 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2020, 2023, 2024 Zheng Junjie <873216071@qq.com>
;;; Copyright © 2022 Brendan Tildesley <mail@brendan.scot>
;;; Copyright © 2022 Petr Hodina <phodina@protonmail.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (kde-testing packages sddm-kcm)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix build-system qt)
  #:use-module (gnu packages)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages display-managers)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages freedesktop)
)


(define-public sddm-kcm
  (package
    (name "sddm-kcm")
    (version "5.27.7")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://kde/stable/plasma/"
                                  version "/" name
                                  "-" version ".tar.xz"))
              (sha256
               (base32
                "0hrw22ihrzph573lkwys6g5bnj72rwff1w1wjq0jzkcr3i8zai86"))))
    (build-system qt-build-system)
    (arguments
      (list #:phases
        #~(modify-phases %standard-phases
          (add-before 'configure 'set-polkit-rules-dir
            ;; Locate actions in our {output,etc-dir}, not that of the polkit input.
            (lambda _
              (setenv "PKG_CONFIG_POLKIT_GOBJECT_1_ACTIONDIR"
                ;; This makes it 'Just Work':
                (string-append #$output "/share/polkit-1/actions")
                ;; This only makes it work when we extend polkit-service-type:
                ;; (string-append "/etc/polkit-1/actions")
                ))))))
     (native-inputs
     (list extra-cmake-modules pkg-config qttools-5))
    (inputs (list
      extra-cmake-modules
      sddm
      ki18n
      qtbase-5
      qtdeclarative-5
      qtquickcontrols-5
      qtquickcontrols2-5
      qtgraphicaleffects
      appstream-qt
      kxmlgui
      kio
      karchive
      knewstuff
      kdeclarative
      kcmutils))
    (home-page "https://invent.kde.org/plasma/sddm-kcm")
    (synopsis "Login Screen (SDDM) System Settings Module")
    (description "sddm-kcm is a KConfig Module (KCM) that integrates itself
into KDE's System Settings and serves the purpose of configuring the
Simple Desktop Display Manager (SDDM) - the recommended display manager
for KDE Plasma.")
    (license license:gpl2+)))
