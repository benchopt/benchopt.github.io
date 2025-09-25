
DEST=$1

# copying the current doc to its destination
rm -rf "$DEST"
cp -r ../doc/_build/html/ "$DEST";
if [ -n "$CIRCLE_TAG" ]; then
                # Also update stable -> copy into "stable/"
                rm -rf stable
                cp -r "$DEST" stable
fi

# Creating the version dropdown
VERSIONS=$(ls -d \d* | sort -Vr | jq -R -s -c 'split("\n")[:-1]')
cat > versions.json <<EOF
{
              "stable": "stable",
              "dev": "dev",
              "versions": $VERSIONS
}
EOF

echo "Deploying dev docs for ${CIRCLE_BRANCH}.";
git add -A
if [[ -z $(git diff --staged) ]]; then
              echo "Nothing to commit"
else
              MSG="Update docs for $DEST (build ${CIRCLE_BUILD_NUM})"
              git commit -m "$MSG";
              git push origin main;
fi

