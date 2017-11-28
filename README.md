# ant-shade-task

`ant-shade-task` is a port of [Apache Maven](https://maven.apache.org/) [Shade Plugin](https://maven.apache.org/plugins/maven-shade-plugin/) (or `maven-shade-plugin`) for [Ant](http://ant.apache.org/).

## How to build

There is a simple ruby script that orchestrates the build into a local directory `dist`. First you update the version
number in the `pom.xml` if required and then you run `./build.rb` and it will build artifacts into `dist` directory
and these can be uploaded to Maven Central or another artifact repository as required.

## How to use

* Register the picked up JAR file in `build.xml`:

```xml
<taskdef
  classpath="ant-shade-task-VERSION.jar"
  resource="org/realityforge/ant/shade/shade.properties"
/>
```

* Apply (an adapted example taken from the Maven Shade Plugin [Relocating Classes example](https://maven.apache.org/plugins/maven-shade-plugin/examples/class-relocation.html)):

```xml
<shade jar="foo-bar.jar" uberJar="foo-bar-shaded.jar">
  <relocation pattern="org.codehaus.plexus.util" shadedPattern="org.shaded.plexus.util">
    <exclude value="org.codehaus.plexus.util.xml.Xpp3Dom"/>
    <exclude value="org.codehaus.plexus.util.xml.pull.*"/>
  </relocation>
</shade>
```

The snippet above is an Ant adaptation of the following Maven Shade Plugin configuration snippet:

```xml
<relocations>
  <relocation>
  <pattern>org.codehaus.plexus.util</pattern>
    <shadedPattern>org.shaded.plexus.util</shadedPattern>
    <excludes>
      <exclude>org.codehaus.plexus.util.xml.Xpp3Dom</exclude>
      <exclude>org.codehaus.plexus.util.xml.pull.*</exclude>
    </excludes>
  </relocation>
</relocations>
```

### How to use in Apache Buildr

Apache Buildr can make use of ant tasks. An example that shades an existing jar in Apache Buildr is:

```ruby
package(:jar).enhance do |jar|
  jar.merge(artifact(:javapoet))
  jar.merge(artifact(:guava))
  jar.enhance do |f|
    shaded_jar = (f.to_s + '-shaded')
    Buildr.ant 'shade_jar' do |ant|
      artifact = Buildr.artifact(:shade_task)
      artifact.invoke
      ant.taskdef :name => 'shade', :classname => 'org.realityforge.ant.shade.Shade', :classpath => artifact.to_s
      ant.shade :jar => f.to_s, :uberJar => shaded_jar do
        ant.relocation :pattern => 'com.squareup.javapoet', :shadedPattern => 'react4j.processor.vendor.javapoet'
        ant.relocation :pattern => 'com.google', :shadedPattern => 'react4j.processor.vendor.google'
      end
    end
    FileUtils.mv shaded_jar, f.to_s
  end
end
```

## What's supported

* Only `<relocations>` are exposed through the `<shade>` task so far.

## Credit

This is simply a re-packaging of [lyubomyr-shaydariv/ant-shade-task](https://github.com/lyubomyr-shaydariv/ant-shade-task)
which wraps the [Apache Maven](https://maven.apache.org/) [Shade Plugin](https://maven.apache.org/plugins/maven-shade-plugin/).
The authors of those libraries deserve all credit.
