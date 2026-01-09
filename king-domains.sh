#!/bin/bash
input=$1
output=$2
tmpfile="$(mktemp /tmp/meuoutput.XXXXXXXX)" || exit 1
tmpfile2="$(mktemp /tmp/meuoutput.XXXXXXXX)" || exit 1
tmpfile3="$(mktemp /tmp/meuoutput.XXXXXXXX)" || exit 1
tmpfile4="$(mktemp /tmp/meuoutput.XXXXXXxx)" || exit 1

sub_domains_finder() {
  for sub in $(cat "$input"); do
    echo "amass sub: $sub"
    amass enum -passive -d "$sub" -o "$tmpfile"
    awk 'NF' "$tmpfile" >> "$tmpfile2"
    > "$tmpfile"
    echo "subfinder sub: $sub"
    subfinder -d "$sub" -o "$tmpfile"
    awk 'NF' "$tmpfile" >> "$tmpfile2"
    > "$tmpfile"
    echo "assetfinder sub: $sub"
    assetfinder --subs-only "$sub" -o "$tmpfile"
    awk 'NF' "$tmpfile" >> "$tmpfile2"
    > "$tmpfile"
  done
}

remove_out_scope() {
  subs_finded=$(cat "$tmpfile2")
  compare=$(cat "$input")
  for subs in $subs_finded; do
    for wildcard in $compare; do
      if [[ $subs == $wildcard ]]; then
        echo "BATE $subs COM $wildcard"
        echo "$subs" >> "$tmpfile3"
      else
        echo "NÂO BATE $subs COM $wildcard"
      fi
#      sleep 0.1
    done
  done
  cat "$tmpfile3" | awk '!seen[$0]++' > "$tmpfile4"
}

ping_test () {
PING_COUNT=3                      # Quantos pings enviar para teste
TIMEOUT=2                      # Timeout em segundos por ping
  for target in $(cat "$tmpfile4"); do
    if ping -l 3 -c "$PING_COUNT" -W "$TIMEOUT" "$target" &> /dev/null; then
        echo "[ OK ] $target"
        echo "$target" >> "$output"
    else
        echo "[ FAIL ] $target"
    fi
  done
  # Espera só no final
  echo "[+] Teste concluído. Subdomínios ativos salvos em: $output"
}
sub_domains_finder
remove_out_scope
ping_test
