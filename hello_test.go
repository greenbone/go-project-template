/* Copyright (C) Greenbone Networks GmbH
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

package hello

import "testing"

func TestHello(t *testing.T) {
	want := "Hello, world."
	if got := Hello(); got != want {
		t.Errorf("Hello() = %q, want %q", got, want)
	}
}
